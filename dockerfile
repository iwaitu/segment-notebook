FROM pytorch/pytorch:2.0.1-cuda11.7-cudnn8-runtime

EXPOSE 8888


RUN apt-get update && apt-get install -y \
    apt-utils \
    vim \
    git 
RUN apt-get install wget gcc g++ -y
RUN apt-get install libsm6 libxext6 -y
RUN apt-get update
RUN apt-get install -y libgl1-mesa-glx

# 避免 debconf 报错
ENV DEBIAN_FRONTEND=noninteractive

# 安装需要的软件包
RUN apt-get update && apt-get install -y \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*


RUN mkdir -p /root/.cache/torch/hub/checkpoints
RUN wget -P /root/.cache/torch/hub/checkpointsr https://github.com/huggingface/pytorch-image-models/releases/download/v0.1-weights/tf_efficientnet_b7_aa-076e3472.pth

ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN pip install pycocotools
RUN pip install opencv-python
RUN pip install opencv-contrib-python -i https://pypi.tuna.tsinghua.edu.cn/simple
RUN pip install git+https://github.com/facebookresearch/fvcore
RUN pip install cython
RUN pip install git+https://github.com/philferriere/cocoapi.git#subdirectory=PythonAPI
RUN python -m pip install 'git+https://github.com/facebookresearch/detectron2.git'

RUN pip install git+https://github.com/facebookresearch/segment-anything.git
RUN pip install -q git+https://github.com/huggingface/transformers.git
RUN pip install datasets
RUN pip install patchify
RUN pip install scipy
RUN pip install scikit-image
RUN pip install scikit-learn
RUN pip install tqdm
RUN pip install tensorflow

RUN pip install jupyterlab notebook
RUN pip install --upgrade jupyter ipywidgets

RUN pip install matplotlib

#RUN COPY requirements.txt .
#RUN pip install -r requirements.txt

ENV JUPYTER_TOKEN=nngeo.net
COPY start-jupyter.sh /usr/local/bin/start-jupyter.sh
RUN chmod +x /usr/local/bin/start-jupyter.sh
CMD ["/usr/local/bin/start-jupyter.sh"]
