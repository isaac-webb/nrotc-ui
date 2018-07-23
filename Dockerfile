# Install the angular cli
FROM node AS angular
ENV NODE_ENV development
RUN ["npm", "install", "-g", "@angular/cli"]

# Make space for the application
WORKDIR /app

# Install application dependencies
FROM angular AS dependencies
COPY package*.json ./
RUN ["npm", "install"]

# Copy over the application files
FROM dependencies AS compiler
COPY . ./

# Compile the app
RUN ["ng", "build", "--prod"]

# Create the web server
FROM nginx:alpine
COPY --from=compiler /app/dist/nrotc-ui /usr/share/nginx/html
