FROM node:18-alpine

WORKDIR /usr/src/app

# Copy dependency definitions and install
COPY package*.json ./
RUN npm install

# Copy application files
COPY . .

# Match the port expected in alb.tf and user_data.sh
EXPOSE 3000

CMD ["npm", "start"]