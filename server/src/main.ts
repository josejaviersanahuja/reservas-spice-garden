import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { AppModule } from './app.module';
import { ApiKeyGuard } from './guards/apiKey.guard';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.useGlobalPipes(new ValidationPipe());
  app.useGlobalGuards(new ApiKeyGuard());
  app.enableCors({
    methods: 'GET,PUT,PATCH,POST',
    origin: new RegExp(process.env.CORS_ORIGIN + '$'),
  });

  const config = new DocumentBuilder()
    .setTitle('Spice Garden API')
    .setDescription('REST API for Spice Garden Reservation Sytem')
    .setVersion('1.0')
    .build();
  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('docs', app, document);

  await app.listen(3001);
}
bootstrap();
