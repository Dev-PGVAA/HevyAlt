import { IsArray, IsOptional, IsString } from 'class-validator'
import { Equipment, ExerciseType, MuscleGroup } from 'prisma/generated/client'

export class ExerciseDto {
	@IsString()
	name: string

	@IsString()
	@IsOptional()
	description?: string

	@IsString()
	@IsArray()
	PrimaryMuscleGroup: MuscleGroup[]

	@IsString()
	@IsArray()
	OtherMuscles: MuscleGroup[]

	@IsString()
	equipment: Equipment

	@IsString()
	ExerciseType: ExerciseType
}
