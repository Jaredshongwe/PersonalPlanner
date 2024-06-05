# Use the .NET SDK as the base image for building the application
FROM mcr.microsoft.com/dotnet/sdk AS build
WORKDIR /app

# Copy the project files into the container
COPY *.csproj ./
RUN dotnet restore

# Copy the remaining source code into the container
COPY . ./

# Build the application
RUN dotnet build -c Release -o /app/build

# Publish the application
FROM build AS publish
RUN dotnet publish -c Release -o /app/publish

# Use the ASP.NET Core runtime as the base image for running the application
FROM mcr.microsoft.com/dotnet/aspnet AS final
WORKDIR /app
COPY --from=publish /app/publish .

# Set the environment variables
ENV MONGODB_CONNECTION_STRING=mongodb+srv://team04:X0QZDHtKPev5cv1B@team4cluster.hfsodnz.mongodb.net/
ENV MONGODB_DATABASE_NAME=PersonalPlanner

# Expose port 80 for the application
EXPOSE 80

# Start the application
ENTRYPOINT ["dotnet", "PersonalPlanner.dll"]
