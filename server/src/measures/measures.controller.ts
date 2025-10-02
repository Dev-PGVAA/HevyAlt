import { Body, Controller, Get, Post } from '@nestjs/common'
import { Auth } from 'src/auth/decorators/auth.decorator'
import { CurrentUser } from 'src/auth/decorators/user.decorator'
import { UpdateMeasuresDto } from './dto/measures.dto'
import { MeasuresService } from './measures.service'

@Controller('measures')
export class MeasuresController {
	constructor(private readonly measuresService: MeasuresService) {}

	@Get()
	@Auth()
	async getAllMeasures(@CurrentUser('id') userId: string) {
		return this.measuresService.getAllMeasure(userId)
	}

	@Post('update')
	@Auth()
	async updateMeasures(
		@Body() dto: UpdateMeasuresDto,
		@CurrentUser('id') userId: string
	) {
		return this.measuresService.updateMeasure(dto, userId)
	}
}
