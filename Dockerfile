FROM python:3.11-slim
WORKDIR /usr/app
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir \
    numpy \
    pandas \
    faker \
    psycopg2-binary \
    dbt-core==1.11.6 \
    dbt-postgres==1.10.0

# Remove the ENTRYPOINT and use this instead to keep container alive
CMD ["tail", "-f", "/dev/null"]