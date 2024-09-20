# Docker PHP-FPM 7.4 & Nginx 1.20 on Alpine Linux 3.14
refer to: https://github.com/TrafeX/docker-php-nginx

## Usage

Build image: 
    docker build -t <your image>:<tag> .
Start the Docker container:

    docker run -d -p 80:9000 <your image>:<tag>

See the PHP info on http://localhost, or the static html page on http://localhost/test.html

Or mount your own code to be served by PHP-FPM & Nginx

    docker run -p 80:9000 -v ~/my-codebase:/var/www/html <your image>:<tag>
