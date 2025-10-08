import { Body, Controller, Get, Post } from '@nestjs/common'
import { Auth } from 'src/auth/decorators/auth.decorator'
import { CurrentUser } from 'src/auth/decorators/user.decorator'
import { ExerciseDto } from './dto/exercise.dto'
import { ExerciseService } from './exercise.service'

// TODO: ADD GET EXERCISE BY ID, UPDATE EXERCISE DELETE EXERCISE; ALSO ADD WORKOUT module
@Controller('exercise')
export class ExerciseController {
	constructor(private readonly exerciseService: ExerciseService) {}

	@Post('create')
	@Auth()
	async getAllMeasures(
		@Body() dto: ExerciseDto,
		@CurrentUser('id') userId: string
	) {
		return this.exerciseService.createExercise(dto, userId)
	}

	@Get('get-all')
	@Auth()
	async getAllExercises(@CurrentUser('id') userId: string) {
		return this.exerciseService.getAllExercises(userId)
	}
}
