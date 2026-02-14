# ---------- Build stage ----------
    FROM node:20-alpine AS builder

    WORKDIR /app
    
    # Install dependencies first (cached)
    COPY package*.json ./
    RUN npm install --only=production

    
    # Copy source
    COPY . .
    
    # ---------- Runtime stage ----------
    FROM gcr.io/distroless/nodejs20-debian12:nonroot
    
    WORKDIR /app
    
    # Copy only what's needed
    COPY --from=builder /app /app
    
    # App port
    EXPOSE 8080
    
    # Distroless already runs as nonroot (uid 65532)
    USER nonroot:nonroot
    
    CMD ["index.js"]
    