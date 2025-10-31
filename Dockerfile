# Build stage
FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build-env
WORKDIR /app

# Sadece projeyi restore etmek için csproj dosyalarını kopyala
COPY *.csproj ./

# NuGet restore
RUN dotnet restore

# Tüm kaynakları kopyala
COPY . ./

# Release build ve publish
RUN dotnet publish "Api.csproj" -c Release -o out --no-restore

# Runtime stage
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
WORKDIR /app

# Build stage'den derlenmiş dosyaları al
COPY --from=build-env /app/out .

# Uygulamayı başlat
ENTRYPOINT ["dotnet", "Api.dll", "--urls", "http://0.0.0.0:80"]