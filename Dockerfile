#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0-alpine3.18 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0-alpine3.18 AS build

COPY ./lib/ /src/lib/
COPY ./back-end/ /src/back-end

WORKDIR /src/back-end/LocationTracker
#COPY ["LocationTracker.csproj", "."]
RUN dotnet restore "./LocationTracker.csproj"
#COPY . .
#WORKDIR "/back-end/LocationTracker/."
RUN dotnet build "LocationTracker.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "LocationTracker.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "LocationTracker.dll"]