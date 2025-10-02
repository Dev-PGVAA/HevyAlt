import { Module } from '@nestjs/common'
import { ConfigModule } from '@nestjs/config'
import { AuthModule } from './auth/auth.module'
import { ExerciseModule } from './exercise/exercise.module'
import { MeasuresModule } from './measures/measures.module'
import { MediaModule } from './media/media.module'
import { UserModule } from './user/user.module'

@Module({
	imports: [
		ConfigModule.forRoot(),
		AuthModule,
		UserModule,
		MediaModule,
		MeasuresModule,
		ExerciseModule
	]
})
export class AppModule {}
