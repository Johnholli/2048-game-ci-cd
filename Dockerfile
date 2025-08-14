FROM public.ecr.aws/nginx/nginx:stable-alpine
COPY . /usr/share/nginx/html
