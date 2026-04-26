# ========================================
# ÉTAPE 1 : BUILD
# ========================================
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app

# On copie le pom ET le code source directement
COPY pom.xml .
COPY src ./src

# On lance le package (le téléchargement des dépendances se fera automatiquement ici)
RUN mvn clean package -DskipTests

# ========================================
# ÉTAPE 2 : IMAGE FINALE LÉGÈRE
# ========================================
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8081
ENTRYPOINT ["java", "-XX:+UseContainerSupport", "-XX:MaxRAMPercentage=75.0", "-Djava.security.egd=file:/dev/./urandom", "-jar", "app.jar"]