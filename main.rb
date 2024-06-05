require 'rubyXL'

workbook = RubyXL::Workbook.new
worksheet = workbook[0]

worksheet.add_cell(0,0, 'Número de oficio')
worksheet.add_cell(0,1, 'Estado del documento')

worksheet.add_cell(1,0, 'DA-SRH-1245')
worksheet.add_cell(1,1, 'Escaneado')

workbook.write('registro_de_documentos_escaneados.xlsx')
