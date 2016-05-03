function [] = writeTiFile( name, dataMatrix )
    fileId = fopen(name, 'w');
    fprintf(fileId,'CTI1\n\nCOLOR_REP "RGB"\nNUMBER_OF_FIELDS 4\nBEGIN_DATA_FORMAT\n');
    fprintf(fileId,'SAMPLE_ID RGB_R RGB_G RGB_B\nEND_DATA_FORMAT\n');
    fprintf(fileId,'\nNUMBER_OF_SETS 30\nBEGIN_DATA\n');
    fprintf(fileId, '%d %3.3f %3.3f %3.3f\n', dataMatrix);
    fprintf(fileId,'END_DATA');
    fclose(fileId);
end

