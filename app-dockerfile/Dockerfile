FROM python:2.7
COPY app.py /
ADD templates /templates 
WORKDIR /
RUN pip install flask flask-mysqldb pyyaml
ENTRYPOINT ["python"]
CMD ["app.py"]
