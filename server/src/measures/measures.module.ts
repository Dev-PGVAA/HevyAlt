import { Module } from '@nestjs/common'
import { PrismaService } from 'src/prisma.service'
import { MeasuresController } from './measures.controller'
import { MeasuresService } from './measures.service'

@Module({
	controllers: [MeasuresController],
	providers: [MeasuresService, PrismaService],
	exports: [MeasuresService]
})
export class MeasuresModule {}
