# syntax=docker/dockerfile:1.20
FROM ruby:4.0-trixie AS base

# Default environment
ARG ENVIRONMENT=production
ENV ENVIRONMENT=${ENVIRONMENT}

# Create a non-root user for security
ARG UID=10001
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/usr/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    appuser

# Install required system packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        default-libmysqlclient-dev \
        libmysql++-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy Gem definitions early for layer caching
COPY Gemfile Gemfile.lock ./

# Install gems with caching
RUN --mount=type=cache,target=/usr/local/bundle \
    bundle config set deployment 'true' && \
    bundle config set without 'development test' && \
    bundle install

# Copy the full application code
COPY . .

# Copy entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Expose default Puma port
EXPOSE 9292

# Run as non-root user
USER appuser

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["bundle", "exec", "puma", "-C", "puma.rb"]
