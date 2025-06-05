# Usar a imagem oficial do Nginx como base
FROM nginx:alpine

# Definir o diretório de trabalho
WORKDIR /usr/share/nginx/html

# Copiar arquivos HTML para dentro do container
COPY . .

# Expor a porta 80 para acesso ao servidor
EXPOSE 80

# Iniciar o servidor Nginx
CMD ["nginx", "-g", "daemon off;"]
