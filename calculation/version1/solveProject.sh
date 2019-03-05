#!/bin/bash
#-----------------------------------------------------------------------------#
# =========                 |
# \\      /  F ield         | OpenFOAM: The Open Source CFD Toolbox
#  \\    /   O peration     | Website:  https://github.com/StasF1/intakePipe
#   \\  /    A nd           | Version:  6
#    \\/     M anipulation  |
#------------------------------------------------------------------------------
# License
#     This program is free software: you can redistribute it and/or modify it
#     under the terms of the GNU General Public License as published by
#     the Free Software Foundation, either version 3 of the License, or
#     (at your option) any later version.
#
#     This program is distributed in the hope that it will be useful, but
#     WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
#     or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
#     for more details.
#
#     You should have received a copy of the GNU General Public License
#     along with OpenFOAM.  If not, see <http://www.gnu.org/licenses/>.
#
# Script
#     solveProject
#
# Description
#     Решение проекта с увеличением хода клапана на шаг
#
#------------------------------------------------------------------------------

source ../intakePipeDict.sh

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

startProjectTime=`date +%s` # Включение секундомера для вывода времени расчёта

## Масштабирование файлов .stl
printf 'Scaling *.stl files...\n'
cd 0/geometry
sh scaleSTL.sh > scaleSTL.log 
printf '\nScaling *.stl files has being DONE.'
printf '\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n'
cd ../../

## Создание и решение подпроектов по шагу клапана
printf 'Solving cases by stokes:\n'

# Создание файла давлений на входном сечении по шагам клапана
printf '# Time       	average(p)\n' > inletPatchPressures.txt
stroke=$strokeStart
while [ $stroke -le $strokeEnd ]
do
	printf 'Solving stroke = %s mm:\n' $stroke
	startStrokeTime=`date +%s` # Включение секундомера для вывода времени расчёта подпроекта
	strokeMetres=`echo "scale=3; $stroke*10^(-3)" | bc -l` # Сonverting stroke to metres
	
	# Создание папки подпроекта для шага клапана и изменение под него настроек
	mkdir $stroke
	cp -a 0/* $stroke
	cd $stroke/
	sed -i "s/strokeMetres/$strokeMetres/g" solveCurrentStroke.sh 
	
	sh solveCurrentStroke.sh # Генерация сетки и решение на ней
	
	# Запись в файл давления на входном сечении
	cd case/postProcessing/patchAverage\(p,name=inlet\)/0/
	tail -n1 surfaceFieldValue.dat >> ../../../../../inletPatchPressures.txt
	cd ../../../../../
	
	# Отображение времени расчёта подпроекта
	printf '\n Stroke %s mm has being SOLVED in ' $stroke
	endStrokeTime=`date +%s`
	solveStrokeTime=$((endStrokeTime-startStrokeTime))
	printf '%dh:%dm:%ds\n\n'\
		 $(($solveStrokeTime/3600)) $(($solveStrokeTime%3600/60)) $(($solveStrokeTime%60))

	stroke=`echo "scale=1; $stroke + $strokeDelta" |bc` # Inreasing stroke by one step
done
printf '\nThe project has being SOLVED.'
printf '\n~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n'

# Отображение времени расчёта проекта
endProjectTime=`date +%s`
solveProjectTime=$((endProjectTime-startProjectTime))
printf '#######################\n'
printf 'Solve time: %dh:%dm:%ds\n'\
	 $(($solveProjectTime/3600)) $(($solveProjectTime%3600/60)) $(($solveProjectTime%60))

echo '\007' # звуковой сигнал

# ***************************************************************************** #










