FROM nginx:alpine
COPY Project/Project /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
