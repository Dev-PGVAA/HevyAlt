import { Injectable } from '@nestjs/common'
import { PrismaService } from 'src/prisma.service'
import { ExerciseDto } from './dto/exercise.dto'

@Injectable()
export class ExerciseService {
	constructor(private prisma: PrismaService) {}

	async createExercise(dto: ExerciseDto, userId: string) {
		const exercise = await this.prisma.exercise.create({
			data: {
				...dto,
				user: {
					connect: {
						id: userId
					}
				}
			}
		})

		return exercise
	}
}
