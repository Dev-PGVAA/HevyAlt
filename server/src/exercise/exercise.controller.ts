import { Body, Controller, Post } from '@nestjs/common'
import { Auth } from 'src/auth/decorators/auth.decorator'
import { CurrentUser } from 'src/auth/decorators/user.decorator'
import { ExerciseDto } from './dto/exercise.dto'
import { ExerciseService } from './exercise.service'

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
}
