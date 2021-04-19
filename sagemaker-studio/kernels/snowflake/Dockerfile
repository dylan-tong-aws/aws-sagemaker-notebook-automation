ARG DLC_ACCOUNT=803235869972
ARG REGION=eu-west-1
ARG DLC_REPO=sagemaker_studio_for_snowflake
ARG DLC_TAG=2.4.1-gpu-py37-cu110-ubuntu18.04

FROM ${DLC_ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/${DLC_REPO}:${DLC_TAG}

RUN pip install --upgrade snowflake-connector-python[pandas]==2.3.2 &

RUN pip install ipykernel && \
    python -m ipykernel install --sys-prefix && \
    pip install jupyter_kernel_gateway