FROM mcr.microsoft.com/dotnet/sdk:9.0-alpine AS build
COPY . /build
WORKDIR /build
RUN dotnet publish -c Release ./src/Presentation/Nop.Web/Nop.Web.csproj -o ./published/
RUN cd ./published/ && mkdir bin logs

FROM mcr.microsoft.com/dotnet/aspnet:9.0-alpine AS runtime 
LABEL project="learning" 
LABEL author="khaja"
ARG USERNAME=nop
RUN adduser -D -h /nop -s /bin/sh ${USERNAME}
COPY --from=build --chown=${USERNAME}:${USERNAME} /build/published /nop
ENV ASPNETCORE_URLS="http://0.0.0.0:5000"
EXPOSE 5000
CMD ["dotnet", "Nop.Web.dll"]