					.586
					locals


CodeSegment			segment	use16
					assume	cs : CodeSegment, ss : StackSegment

					include	Dec2Str.inc
					include	Dec2Char.inc

Main				proc
                              
					mov		ax, DataSegment		; Настраиваем сегмент данных
					mov		ds, ax
					mov		es, ax
					assume	ds : DataSegment, es : DataSegment
		
					mov		eax, 12d
					mov		ecx, 8
					call	DoTest

					mov		eax, 14d
					mov		ecx, 9999
					call	DoTest

					mov		eax, 15d
					mov		ecx, 1
					call	DoTest


					mov		ax, 4c00h
					int		21h					; INT 21h - Выход из программы
												; AH = 4Ch
												; AL - код возврата
Main				endp


DoTest				proc

					lea		edi, DecStr

					mov		word ptr es : [edi], '##'
					
					call	DecToStr

					cmp		eax, 0
					je		@@NoError

					cmp		eax, 1
					je		@@BufferToSmall

@@UnknownError:
					mov		dx, offset UnknownErrorMsg
					jmp		@@PrintMessage

@@BufferToSmall:
					mov		dx, offset BufferTooSmallMsg
					jmp		@@PrintMessage

@@NoError:
					
					mov		dx, offset Message

@@PrintMessage:
					mov		ah, 09h
					int		21h					; INT 21h - Вывод строки на экран
												; AH = 09h
												; DS : DX - адрес строки

					lea		dx, NewLineStr
					mov		ah, 9
					int		21h

					ret
DoTest				endp

CodeSegment			ends



DataSegment			segment	use16

Message				label 	byte
					db		'Hex number: '
 DecStr				db		'##'
					db		'$'

BufferTooSmallMsg 	db	'Buffer too small', '$'

UnknownErrorMsg 	db	'Unknown error', '$'

NewLineStr			db	13, 10, '$'

DataSegment			ends



StackSegment		segment	use16 stack 'stack'
					db		4096 dup (0)
StackSegment		ends
		
					end		Main
