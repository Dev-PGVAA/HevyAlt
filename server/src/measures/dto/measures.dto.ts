import { IsDecimal, IsString } from 'class-validator'
import { Measure } from 'prisma/generated/client'

export class UpdateMeasuresDto {
	@IsString()
	TypeOfMeasure: Measure

	@IsDecimal()
	measure: number
}
