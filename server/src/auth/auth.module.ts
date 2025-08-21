import { Module } from '@nestjs/common'
import { ConfigModule, ConfigService } from '@nestjs/config'
import { JwtModule } from '@nestjs/jwt'
import { getJwtConfig } from 'src/config/jwt.config'
import { PrismaService } from 'src/prisma.service'
import { UserModule } from 'src/user/user.module'
import { AuthController } from './auth.controller'
import { AuthService } from './auth.service'
import { JwtStrategy } from './jwt.strategy'
import { SocialController } from './social/social.controller'
import { SocialService } from './social/social.service'
import { GoogleStrategy } from './social/strategies/google.strategy'

@Module({
	controllers: [AuthController, SocialController],
	providers: [
		AuthService,
		PrismaService,
		JwtStrategy,
		SocialService,
		GoogleStrategy
	],
	imports: [
		UserModule,
		ConfigModule,
		JwtModule.registerAsync({
			imports: [ConfigModule],
			inject: [ConfigService],
			useFactory: getJwtConfig
		})
	]
})
export class AuthModule {}
