import { Module } from '@nestjs/common'
import { ConfigModule } from '@nestjs/config'
import { AuthModule } from './auth/auth.module'
import { MediaModule } from './media/media.module'
import { UserModule } from './user/user.module'

@Module({
	imports: [ConfigModule.forRoot(), AuthModule, UserModule, MediaModule]
})
export class AppModule {}
