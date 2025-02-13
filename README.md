# VPN
En primer lugar, vamos a crear las máquinas virtuales en AWS. Necesitaremos 3 máquinas:

└── Máquinas virtuales  
    ├── VPN  
    ├── CA  
    └── Base de datos

En primer lugar, crearemos la CA (Autoridad Certificadora) en AWS. Usaremos Ubuntu 24 con una t2.micro  

Archivo de configuración en Visual Code para poder trabajar con SSH:  
![image](https://github.com/user-attachments/assets/1d4109e7-d202-4cea-9a41-0c56644132d5)  
En HostName ponemos nuestra IP pública, y en IdentifyFile nuestra clave PEM.  

![image](https://github.com/user-attachments/assets/db214b45-2222-4240-95cb-4b75603f37ae)  
