# 🌾 Farm Connect - Agricultural Marketplace Platform

A comprehensive digital platform connecting farmers, buyers, and administrators for seamless agricultural trade and management.

## 🎯 Overview

Farm Connect is a full-stack web application designed to modernize agricultural commerce by providing:
- **Farmers**: Product listing, crop cycle management, order fulfillment
- **Buyers**: Product browsing, order placement, farmer connections
- **Admins**: User management, government scheme administration, platform oversight

## 🏗️ Architecture

### Technology Stack

**Frontend:**
- React 19.2.3
- Vite (Build tool)
- TailwindCSS
- Radix UI Components
- Axios (API client)

**Backend:**
- Spring Boot 3.2.5
- Java 21
- Spring Security + JWT
- Spring Data JPA
- MySQL 8.0

**Infrastructure:**
- Docker & Docker Compose
- Nginx (Reverse Proxy)
- GitHub Actions (CI/CD)

**External Services:**
- Cloudinary (Image hosting)
- OpenWeatherMap (Weather data)

## 🚀 Quick Start

### Prerequisites

- Docker Desktop (or Docker + Docker Compose)
- Git
- 4GB RAM minimum

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd final_dac_project
   ```

2. **Configure environment**
   ```bash
   cp .env.example .env.production
   ```
   
   Edit `.env.production` with your values:
   - MySQL credentials
   - JWT secret key
   - Cloudinary credentials
   - Weather API key

3. **Start the application**
   
   **Windows:**
   ```cmd
   scripts\start.bat
   ```
   
   **Linux/Mac:**
   ```bash
   chmod +x scripts/deploy.sh
   ./scripts/deploy.sh
   ```

4. **Access the application**
   - Frontend: http://localhost
   - Backend API: http://localhost/api
   - API Docs: http://localhost/api/swagger-ui.html

## 📁 Project Structure

```
final_dac_project/
├── backend/Backend/          # Spring Boot backend
│   ├── src/
│   ├── Dockerfile
│   ├── pom.xml
│   └── ...
├── frontend/Frontend/        # React frontend
│   ├── src/
│   ├── Dockerfile
│   ├── package.json
│   └── ...
├── nginx/                    # Nginx reverse proxy
│   ├── nginx.conf
│   └── Dockerfile
├── scripts/                  # Deployment scripts
│   ├── deploy.sh
│   ├── backup.sh
│   └── ...
├── .github/workflows/        # CI/CD pipelines
│   ├── ci-cd.yml
│   └── build-test.yml
├── docker-compose.yml        # Production setup
├── docker-compose.dev.yml    # Development setup
├── .env.example              # Environment template
├── DEPLOYMENT.md             # Deployment guide
├── QUICKREF.md               # Quick reference
└── GITHUB_SETUP.md           # CI/CD setup guide
```

## 🎨 Features

### For Farmers
- ✅ Register and manage farm profile
- ✅ List products with images and descriptions
- ✅ Track crop cycles and growth stages
- ✅ Manage orders and inventory
- ✅ Access government schemes and subsidies
- ✅ View weather forecasts
- ✅ Digital wallet for transactions

### For Buyers
- ✅ Browse available products
- ✅ Search and filter by category, location, price
- ✅ Add to cart and place orders
- ✅ Connect directly with farmers
- ✅ Track order history
- ✅ Save favorite products
- ✅ Secure payment processing

### For Administrators
- ✅ User management (farmers & buyers)
- ✅ Product approval and moderation
- ✅ Order monitoring
- ✅ Government scheme management
- ✅ Platform analytics and reports
- ✅ System configuration

## 🔧 Development

### Local Development (Without Docker)

**Backend:**
```bash
cd backend/Backend
./mvnw spring-boot:run
```

**Frontend:**
```bash
cd frontend/Frontend
npm install
npm run dev
```

**Database:**
```bash
docker run -d \
  --name mysql-dev \
  -e MYSQL_ROOT_PASSWORD=root123 \
  -e MYSQL_DATABASE=farm_backend \
  -p 3306:3306 \
  mysql:8.0
```

### Local Development (With Docker)

```bash
docker-compose -f docker-compose.dev.yml up -d
```

## 🧪 Testing

### Backend Tests
```bash
cd backend/Backend
./mvnw test
```

### Frontend Tests
```bash
cd frontend/Frontend
npm test
```

### Integration Tests
```bash
docker-compose -f docker-compose.test.yml up --abort-on-container-exit
```

## 📦 Deployment

See [DEPLOYMENT.md](DEPLOYMENT.md) for comprehensive deployment instructions.

### Quick Deploy to Production

1. Configure `.env.production` with production values
2. Run deployment script:
   ```bash
   ./scripts/deploy.sh
   ```
3. Verify health: 
   ```bash
   curl http://localhost/nginx-health
   curl http://localhost/api/health
   ```

### CI/CD with GitHub Actions

See [GITHUB_SETUP.md](GITHUB_SETUP.md) for GitHub Actions setup.

Automatic deployment on push to `main`:
```bash
git push origin main
```

## 🔐 Security

### Environment Variables

**Never commit these files:**
- `.env.production`
- `.env.local`
- Any files containing credentials

### Key Security Features
- JWT-based authentication
- Password encryption (BCrypt)
- HTTPS/SSL support (production)
- Rate limiting on API endpoints
- CORS configuration
- SQL injection prevention (JPA)
- XSS protection headers
- Input validation and sanitization

## 📊 Monitoring & Maintenance

### View Logs
```bash
docker-compose logs -f
docker-compose logs -f backend
```

### Database Backup
```bash
./scripts/backup.sh
```

### Database Restore
```bash
./scripts/restore.sh backups/farm_backend_YYYYMMDD.sql.gz
```

### Health Checks
- Nginx: http://localhost/nginx-health
- Backend: http://localhost/api/health
- Frontend: http://localhost/health

### Resource Monitoring
```bash
docker stats
docker system df
```

## 🐛 Troubleshooting

### Common Issues

**Port already in use:**
```bash
# Check what's using the port
netstat -ano | findstr :80
# Stop the conflicting service or change port in docker-compose.yml
```

**Database connection failed:**
```bash
# Check MySQL is running
docker-compose ps mysql
# View MySQL logs
docker-compose logs mysql
```

**Backend not starting:**
```bash
# View backend logs
docker-compose logs backend
# Check environment variables
docker-compose exec backend env
```

See [DEPLOYMENT.md](DEPLOYMENT.md) for more troubleshooting guides.

## 📚 Documentation

- [Deployment Guide](DEPLOYMENT.md) - Complete production deployment
- [Quick Reference](QUICKREF.md) - Common commands and URLs
- [GitHub Setup](GITHUB_SETUP.md) - CI/CD configuration
- [API Documentation](http://localhost/api/swagger-ui.html) - Interactive API docs

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 API Endpoints

### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login user

### Products
- `GET /api/products` - List all products
- `POST /api/products` - Create product (Farmer)
- `GET /api/products/{id}` - Get product details
- `PUT /api/products/{id}` - Update product (Farmer)
- `DELETE /api/products/{id}` - Delete product (Farmer)

### Orders
- `POST /api/orders` - Create order (Buyer)
- `GET /api/orders` - List user orders
- `GET /api/orders/{id}` - Get order details
- `PUT /api/orders/{id}/status` - Update order status

### Wallet
- `GET /api/wallet/balance` - Get wallet balance
- `POST /api/wallet/add` - Add funds
- `POST /api/wallet/transfer` - Transfer funds

See full API documentation at: http://localhost/api/swagger-ui.html

## 🌐 Environment Variables

### Required Variables

```env
# Database
MYSQL_ROOT_PASSWORD=your_password
MYSQL_DATABASE=farm_backend
MYSQL_USER=farm_user
MYSQL_PASSWORD=your_password

# JWT
JWT_SECRET=your_256_bit_secret
JWT_EXPIRATION=86400000

# Cloudinary
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_API_KEY=your_api_key
CLOUDINARY_API_SECRET=your_api_secret

# Weather API
WEATHER_API_KEY=your_weather_api_key
WEATHER_API_BASE_URL=https://api.openweathermap.org/data/2.5

# Frontend
VITE_API_URL=/api
```

See `.env.example` for complete list.

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👥 Team

- **Backend Development**: Spring Boot, MySQL, Security
- **Frontend Development**: React, UI/UX
- **DevOps**: Docker, CI/CD, Nginx

## 🙏 Acknowledgments

- Spring Boot framework
- React ecosystem
- Docker community
- OpenWeatherMap API
- Cloudinary service

## 📞 Support

For issues and questions:
- Create an issue on GitHub
- Check [DEPLOYMENT.md](DEPLOYMENT.md) troubleshooting section
- Review logs: `docker-compose logs -f`

---

**Version**: 1.0.0  
**Last Updated**: February 3, 2026  
**Status**: Production Ready ✅
