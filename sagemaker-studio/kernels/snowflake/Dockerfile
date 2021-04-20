FROM python:3.6

RUN pip install sagemaker && \
    pip install --upgrade snowflake-connector-python[pandas]==2.3.2 && \
    pip install ipykernel && \
    python -m ipykernel install --sys-prefix && \
    pip install jupyter_kernel_gateway