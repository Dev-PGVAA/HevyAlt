import { Module } from '@nestjs/common'
import { PrismaService } from 'src/prisma.service'
import { ExerciseController } from './exercise.controller'
import { ExerciseService } from './exercise.service'

@Module({
	controllers: [ExerciseController],
	providers: [ExerciseService, PrismaService],
	exports: [ExerciseService]
})
export class ExerciseModule {}
