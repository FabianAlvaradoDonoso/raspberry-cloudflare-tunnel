## 🏗️ Arquitectura Completa de tu Servidor Raspberry Pi
📊 Diagrama de Arquitectura
```
Internet (Usuarios)
    ↓
☁️  Cloudflare (DNS + SSL automático + Protección DDoS)
    ↓
🔒 Cloudflare Tunnel (Conexión cifrada, sin puertos abiertos)
    ↓
🏠 Red Local (192.168.100.20)
    ↓
🐳 Docker Network (bridge:  web)
    ↓
📦 Nginx (Reverse Proxy)
    ├─→ 🎨 Portafolio Astro (portafolio: 3000)
    ├─→ ⚛️  React App (frontend1:3000)
    └─→ 🐍 API FastAPI (api1:8000)
```

## 🖥️ Hardware
| Componente     | Especificación                                 |
| -------------- | ---------------------------------------------- |
| Modelo         | Raspberry Pi 5                                 |
| RAM            | 8GB LPDDR4X                                    |
| Procesador     | Broadcom BCM2712 Quad-Core Cortex-A76 @ 2.4GHz |
| Almacenamiento | SSD Lexar SL300 1TB (USB 3.0)                  |
| Refrigeración  | Active Cooler oficial con ventilador           |
| Red            | Ethernet Gigabit (IP estática: 192.168.100.20) |

## 🌐 Servicios de Infraestructura
### 1. Cloudflare (Capa externa)
- Dominio: redpandachile.dev
- Funciones:
  - DNS autoritativo
  - SSL/TLS automático (certificados gestionados)
  - Protección DDoS
  - Firewall de aplicaciones web (WAF)
  - CDN para assets estáticos
### 2. Cloudflare Tunnel (Conexión segura)
- Contenedor: cloudflared
- Función: Túnel cifrado entre Cloudflare y tu Raspberry
- Ventajas:
    - ✅ Sin puertos abiertos en el router (NAT traversal)
    - ✅ Funciona con CGNAT
    - ✅ Conexión saliente (bypass de firewall ISP)
    - ✅ IP pública no necesaria
### 3. Nginx (Reverse Proxy)
- Contenedor: nginx
- Puerto interno: 80
- Función: Enrutar tráfico a diferentes aplicaciones según el dominio/subdominio
- Configuración:
    - Virtual hosts por subdominio
    - Proxy pass a contenedores internos
    - Headers de seguridad
    - Compresión gzip
    - Cache de assets estáticos
### 4. Docker + Docker Compose
- Función: Orquestación de contenedores
- Red: web (bridge network interna)
- Ventajas:
    - Aislamiento de aplicaciones
    - Despliegue reproducible
    - Fácil escalabilidad
    - Rollback sencillo


## 🚀 Aplicaciones Desplegadas
### 1. Portafolio Personal (Astro + pnpm)
- URL pública: https://portafolio.redpandachile.dev (o dominio raíz)
- Contenedor: portafolio
- Puerto interno: 3000
- Stack tecnológico:
  - Astro (Static Site Generator)
  - pnpm (gestor de paquetes)
  - Nginx Alpine (servidor web en contenedor)
- Características:
  - Sitio estático optimizado
  - Carga ultra-rápida
  - SEO optimizado
  - Build con multi-stage Docker
### 2. Aplicación React (frontend1)
- URL pública: https://app1.redpandachile.dev
- Contenedor: frontend1
- Puerto interno: 3000
- Stack tecnológico:
  - React con Vite
  - pnpm
  - Nginx Alpine (SPA routing)
- Características:
  - Single Page Application
  - Hot reload en desarrollo
  - Integración con API
### 3. API FastAPI (api1)
- URL pública: https://api.redpandachile.dev
- Contenedor: api1
- Puerto interno: 8000
- Stack tecnológico:
  - Python 3.11
  - FastAPI
  - Uvicorn (ASGI server)
- Endpoints:
  - GET / - Información de la API
  - GET /health - Health check
  - GET /docs - Documentación automática (Swagger)
- Características:
  - CORS configurado
  - Documentación interactiva
  - Validación automática con Pydantic

## 🔒 Seguridad
### Capa de Red
| Servicio | Puerto | Estado                                |
| -------- | ------ | ------------------------------------- |
| SSH      | 22     | ✅ Abierto (UFW)                       |
| HTTP     | 80     | ❌ Cerrado externamente (solo interno) |
| HTTPS    | 443    | ❌ Cerrado externamente                |
### Protecciones Activas
- ✅ UFW Firewall: Solo SSH permitido externamente
- ✅ Fail2ban: Protección contra fuerza bruta SSH
- ✅ Cloudflare Tunnel: Sin exposición directa
- ✅ Headers de seguridad: X-Frame-Options, CSP, etc.
- ✅ SSL/TLS: Certificados automáticos de Cloudflare

📂 Estructura de Directorios
```
/home/[TU-USUARIO]/
├── cloudflare-tunnel/
│   ├── docker-compose.yml          # Orquestación de todos los servicios
│   ├── html/                        # Landing page estática
│   │   └── index.html
│   └── nginx/
│       └── nginx.conf               # Configuración del reverse proxy
│
└── apps/
    ├── portafolio/                  # 🎨 Portafolio Astro
    │   ├── Dockerfile
    │   ├── nginx. conf
    │   ├── package.json
    │   ├── pnpm-lock.yaml
    │   ├── astro.config.mjs
    │   └── src/
    │
    ├── frontend1/                   # ⚛️  App React
    │   ├── Dockerfile
    │   ├── nginx.conf
    │   ├── package.json
    │   ├── pnpm-lock.yaml
    │   └── src/
    │
    └── api1/                        # 🐍 API FastAPI
        ├── Dockerfile
        ├── requirements.txt
        └── main.py
```

## 🔄 Flujo de una Petición
### Ejemplo: Usuario visita https://portafolio.redpandachile.dev

### 1. DNS Resolution:
    - Usuario hace request → DNS de Cloudflare
    - Responde con IP de Cloudflare (no tu IP real)

### 2. Cloudflare Edge:
    - Termina SSL/TLS
    - Aplica reglas de firewall
    - Cachea assets si aplica

### 3. Cloudflare Tunnel:
    - Envía request cifrado por el túnel
    - Contenedor cloudflared recibe en Raspberry

### 4. Nginx (Reverse Proxy):
    - Examina header Host:  portafolio.redpandachile.dev
    - Busca server block correspondiente
    - Hace proxy_pass a http://portafolio:3000
### 5. Contenedor Portafolio:
    - Nginx interno sirve archivo estático desde /usr/share/nginx/html
    - Devuelve HTML/CSS/JS

### 6. Respuesta al Usuario:
- Pasa por Nginx → Tunnel → Cloudflare → Usuario
- Usuario recibe página con HTTPS

## 📊 Recursos del Sistema

### Uso Estimado de RAM (con 3 apps)
| Servicio           | RAM Estimada          |
| ------------------ | --------------------- |
| Sistema operativo  | ~500 MB               |
| Docker daemon      | ~100 MB               |
| Nginx (proxy)      | ~10 MB                |
| cloudflared        | ~30 MB                |
| Portafolio (Nginx) | ~10 MB                |
| Frontend1 (Nginx)  | ~10 MB                |
| API1 (FastAPI)     | ~100 MB               |
| Total              | ~760 MB / 8 GB        |
| Disponible         | ~7.2 GB para más apps |

### Capacidad de Escalamiento
- RAM disponible: ~7.2 GB
- Apps adicionales posibles: 5-7 aplicaciones más
- Limitación: CPU (4 cores) antes que RAM

## 🛠️ Comandos de Gestión
### Operaciones Comunes
```bash
# Ver estado de todos los servicios
docker compose ps

# Ver logs en tiempo real
docker compose logs -f

# Reiniciar un servicio específico
docker compose restart portafolio

# Actualizar una app
docker compose up -d --build frontend1

# Ver uso de recursos
docker stats

# Detener todo
docker compose down

# Iniciar todo
docker compose up -d
```

### Monitoreo
```bash
# Uso de CPU/RAM de la Raspberry
htop

# Temperatura del sistema
vcgencmd measure_temp

# Espacio en disco
df -h

# Estado del firewall
sudo ufw status
```
## 🎯 Ventajas de tu Arquitectura

| Ventaja       | Descripción                                            |
| ------------- | ------------------------------------------------------ |
| 🔒 Seguridad   | Sin puertos expuestos, protección DDoS, SSL automático |
| ⚡ Rendimiento | SSD rápido, contenedores ligeros, cache en Cloudflare  |
| 📈 Escalable   | Fácil agregar nuevas apps con Docker Compose           |
| 🔧 Mantenible  | Infraestructura como código, fácil rollback            |
| 💰 Económico   | Self-hosting sin costos de VPS/cloud                   |
| 🌍 Accesible   | Funciona con CGNAT, sin IP pública estática            |
| 🧪 Laboratorio | Entorno de desarrollo y pruebas completo               |
