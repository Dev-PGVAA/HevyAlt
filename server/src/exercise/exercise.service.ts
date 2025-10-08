import { Injectable } from '@nestjs/common'
import { PrismaService } from 'src/prisma.service'
import { ExerciseDto } from './dto/exercise.dto'

@Injectable()
export class ExerciseService {
	constructor(private prisma: PrismaService) {}

	async createExercise(dto: ExerciseDto, userId: string) {
		const exercise = await this.prisma.exercise.create({
			data: {
				name: dto.name,
				description: dto.description,
				primaryMuscleGroup: dto.PrimaryMuscleGroup,
				otherMuscles: dto.OtherMuscles,
				equipment: dto.equipment,
				exerciseType: dto.ExerciseType,
				user: {
					connect: {
						id: userId
					}
				}
			}
		})

		return exercise
	}

	async getAllExercises(userId: string) {
		const exercises = await this.prisma.exercise.findMany({
			where: { userId }
		})

		return exercises
	}
}
