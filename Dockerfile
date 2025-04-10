FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base

# Install other dependencies as needed
RUN apt-get update && apt-get install -y libicu-dev

WORKDIR /app
EXPOSE 5179

ENV ASPNETCORE_URLS=http://+:5179

USER app
FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:9.0 AS build
ARG configuration=Release
WORKDIR /src
COPY ["HelloApiPipeline/HelloAPiJen/HelloAPiJen.csproj", "HelloApiPipeline/HelloAPiJen/"]
RUN dotnet restore "HelloApiPipeline/HelloAPiJen/HelloAPiJen.csproj"
COPY . .
WORKDIR "/src/HelloApiPipeline/HelloAPiJen"
RUN dotnet build "HelloAPiJen.csproj" -c $configuration -o /app/build

FROM build AS publish
ARG configuration=Release
RUN dotnet publish "HelloAPiJen.csproj" -c $configuration -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "HelloAPiJen.dll"]
