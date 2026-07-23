# build stage: compile and publish using the SDK
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# copy the project file and restore first, so this layer stays cached
COPY src/ShipIt/ShipIt.csproj src/ShipIt/
RUN dotnet restore src/ShipIt/ShipIt.csproj

# now copy the rest of the source and publish (restore again in case the
# separate restore layer above and the publish layer disagree on the
# resolved package set -- dotnet publish is a no-op restore-wise if nothing
# changed, so this costs nothing when the cache above is warm)
COPY . .
RUN dotnet publish src/ShipIt -c Release -o /app

# runtime stage: small image, only the published app
FROM mcr.microsoft.com/dotnet/aspnet:10.0
WORKDIR /app
COPY --from=build /app .
USER $APP_UID
ENTRYPOINT ["dotnet", "ShipIt.dll"]
