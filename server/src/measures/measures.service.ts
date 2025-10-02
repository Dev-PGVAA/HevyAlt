import { Injectable } from '@nestjs/common'
import { MEASURES_ENUM } from 'src/constants/measures.constants'
import { PrismaService } from 'src/prisma.service'
import { UpdateMeasuresDto } from './dto/measures.dto'

@Injectable()
export class MeasuresService {
	constructor(private prisma: PrismaService) {}

	async updateMeasure(dto: UpdateMeasuresDto, userId: string) {
		const measure = await this.prisma.measures.create({
			data: {
				...dto,
				user: {
					connect: {
						id: userId
					}
				}
			}
		})

		return measure
	}

	async getAllMeasure(userId: string) {
		const measures = await this.prisma.measures.findMany({
			where: { userId },
			select: {
				TypeOfMeasure: true,
				measure: true,
				updatedAt: true
			},
			orderBy: { updatedAt: 'desc' }
		})

		const result = Object.keys(MEASURES_ENUM)
			.filter(key => isNaN(Number(key))) // Исключаем числовые ключи
			.reduce((acc, measureName) => {
				const userMeasures = measures.filter(
					m => m.TypeOfMeasure === measureName
				)

				acc[measureName] = {
					now: userMeasures[0]?.measure?.toString() ?? '-',
					history:
						userMeasures.length > 0
							? userMeasures.map(m => ({
									date: m.updatedAt.toISOString(),
									measure: m.measure?.toString() ?? '-'
								}))
							: []
				}

				return acc
			}, {})

		return result
	}
}
