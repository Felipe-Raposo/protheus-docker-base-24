FROM feliperaposo/protheus-baselight:24
LABEL maintainer="Felipe Raposo <feliperaposo@gmail.com>"
COPY ./root/ /
CMD ["/protheus.sh"]
