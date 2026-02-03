# Deploy Farm Connect to Render using Docker

## Prerequisites
- Docker images built in Docker Hub (aj783/farm-backend, aj783/farm-frontend, aj783/farm-nginx)
- GitHub account connected to Render
- Render account (free): https://render.com/

## Deployment Options

### Option 1: Deploy from Docker Hub (Recommended - Fastest)

#### 1. Deploy MySQL Database
```
1. Go to: https://dashboard.render.com/
2. Click "New +" → "PostgreSQL" (Free MySQL alternative)
   OR use external MySQL (like PlanetScale free tier)
3. Name: farm-mysql-db
4. Database: farm_connect_db
5. User: farmuser
6. Copy the Internal Database URL
```

#### 2. Deploy Backend
```
1. Click "New +" → "Web Service"
2. Select "Deploy an existing image from a registry"
3. Image URL: aj783/farm-backend:latest
4. Name: farm-connect-backend
5. Region: Choose closest
6. Instance Type: Free
7. Environment Variables:
   - SPRING_DATASOURCE_URL=jdbc:mysql://[DB_HOST]:[DB_PORT]/farm_connect_db
   - SPRING_DATASOURCE_USERNAME=farmuser
   - SPRING_DATASOURCE_PASSWORD=[YOUR_DB_PASSWORD]
   - JWT_SECRET=[GENERATE_RANDOM_STRING]
   - JWT_EXPIRATION=86400000
   - SERVER_PORT=8080
8. Health Check Path: /actuator/health
9. Click "Create Web Service"
10. Copy the service URL (e.g., https://farm-connect-backend.onrender.com)
```

#### 3. Deploy Frontend
```
1. Click "New +" → "Web Service"
2. Select "Deploy an existing image from a registry"
3. Image URL: aj783/farm-frontend:latest
4. Name: farm-connect-frontend
5. Instance Type: Free
6. Environment Variables:
   - VITE_API_URL=https://farm-connect-backend.onrender.com/api
7. Click "Create Web Service"
8. Your app will be live at: https://farm-connect-frontend.onrender.com
```

### Option 2: Deploy from GitHub Repository

#### 1. Connect GitHub
```
1. Go to: https://dashboard.render.com/
2. Click "New +" → "Blueprint"
3. Connect your GitHub account
4. Select: Agricultural-portal/farm-deployment
5. Render will auto-detect render.yaml
6. Set environment variables
7. Click "Apply"
```

## Free Tier Limitations

- Services sleep after 15 minutes of inactivity
- Cold start takes ~30-60 seconds
- 750 hours/month free compute (enough for 1 service 24/7)
- Multiple services share the free hours

## Alternative: Use Render PostgreSQL Instead of MySQL

If you want fully free hosting, convert MySQL to PostgreSQL:

**Backend changes needed:**
```xml
<!-- In pom.xml, replace mysql-connector with -->
<dependency>
    <groupId>org.postgresql</groupId>
    <artifactId>postgresql</artifactId>
    <scope>runtime</scope>
</dependency>
```

```properties
# In application.properties
spring.datasource.url=${DATABASE_URL}
spring.jpa.database-platform=org.hibernate.dialect.PostgreSQLDialect
```

## Cost Estimate
- **Free Tier**: $0/month (with sleep on inactivity)
- **Paid Tier**: $7/month per service (no sleep)

## Troubleshooting

**Issue**: Service won't start
- Check logs in Render dashboard
- Verify environment variables
- Check Docker image exists in Docker Hub

**Issue**: Database connection failed
- Verify DATABASE_URL format
- Check database credentials
- Ensure database is in same region

**Issue**: CORS errors
- Add Render frontend URL to backend CORS config
- Rebuild and redeploy backend

## Next Steps After Deployment

1. Test the application: https://farm-connect-frontend.onrender.com
2. Monitor logs in Render dashboard
3. Set up custom domain (optional)
4. Enable auto-deploy from GitHub (optional)

## Support
- Render Docs: https://render.com/docs
- Community: https://community.render.com/
