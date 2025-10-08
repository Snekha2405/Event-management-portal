# --------------------------
# Stage 1: Build React frontend
# --------------------------
FROM node:20-alpine AS frontend-build

WORKDIR /app/frontend

# Copy frontend package files
COPY frontend/package*.json ./

# Install all dependencies
RUN npm install

# Copy frontend source code
COPY frontend/ ./

# Build frontend
RUN npm run build

# --------------------------
# Stage 2: Backend setup
# --------------------------
FROM node:20-alpine AS backend-build

WORKDIR /app/backend

# Copy backend package files
COPY backend/package*.json ./

# Install production dependencies only
RUN npm install --omit=dev

# Copy backend source code
COPY backend/ ./

# --------------------------
# Stage 3: Final lightweight image
# --------------------------
FROM node:20-alpine

WORKDIR /app

# Copy backend
COPY --from=backend-build /app/backend ./backend

# Copy frontend build
COPY --from=frontend-build /app/frontend/build ./frontend/build

# Copy cleanup script
COPY cleanup.sh /cleanup.sh
RUN chmod +x /cleanup.sh

# Expose backend port
EXPOSE 5000

# Start container with log cleanup and backend server
CMD ["/bin/sh", "-c", "/cleanup.sh && node backend/server.js"]
