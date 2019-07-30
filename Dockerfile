FROM openjdk:12-alpine as gradlew

WORKDIR /work
ADD gradlew .
ADD gradle gradle
ADD settings.gradle .
ADD build.gradle .
RUN ./gradlew

FROM gradlew as build

ADD src src
RUN ./gradlew shadowJar

FROM openjdk:12-alpine

COPY --from=build /work/build/libs/ .
USER nobody

ENTRYPOINT ["java", "-Djetty.host=0.0.0.0", "-jar", "hypergraphql-1.0.3-exe.jar"] 
