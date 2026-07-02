# cloud_integrations
Proyecto de Solución integradas en la nube para la maestría Ciencias de la Computación.

## Revisión inicial

```
brew --version
git --version
az --version
terraform --version
kubectl version --client
```
En mi caso me hacía falta instalar `az` Por lo que usamos `Brew` para la instalación

```
brew update && brew install azure-cli
```

## Iniciar sesión en Azure
Ingresar el siguiente comando
```
az login
```
Este abrirá una pestaña en el navegador para autorizar el inicio de sesión.

**Nota**: Uno de los problemas que me mostró que tengo configurado la autenticación de 2 pasos. Entonces falló la conexión. Pero posterior a ya haber iniciado la sesión. Volví a ejecutar el mismo comando y ya funcionó.

## Mostrar la cuenta 
Ingresar el siguiente comando
```
az account show
```

## Crear el Grupo de Recursos
Ingresar el siguiente comando
```
az group create --name RG-medinillag --location eastus
```
Eso crea el grupo de recurso con el nombre `RG-medinillag`en la ubicación de `eastus` 

## Creación del service principal
Ingresar el siguiente comando:
```
az ad sp create-for-rbac --name "terraform" --rol Contributor --scopes /subscriptions/<mi_subscription_id>/resourceGroups/RG-medinillag
```
Acá se asocia el service principal al grupo de recursos antes creado, otorgandole el rol de Contributor. Es importante aclarar que mi_subscription_id lo obtuve posterior a iniciar sesión en la consola con el comando `az login`


## Creación de clave ssh
Ingresar el siguiente comando:
```
ssh-keygen -t rsa -b 4096
```
esto genera una llave pública y privada, es importante no compartir la llave privada, para la revisión de la creación correcta ingresar el siguiente comando:
```
cat ~/.ssh/id_rsa.pub
```
Deberá de salir una cadena de texto

## Código en terraform
Revisar el archivo `main.tf`

## Iniciar terraform
Ingresar el siguiente comando:
```
terraform init
```
Debemos de leer un mensaje de creación de proyecto exitoso

## Verificar el plan de ejecución
Ingresar el siguiente comando:
```
terraform plan
```
Acá listará todos los cambios que se aplicarán en este caso al ser un proyecto nuevo, solo será creación, no debería de mostrar algo en actualización o eliminación.

## Aplicar cambios
Ingresar el siguiente comando:
```
terraform apply
```
Aplicará los cambios antes listados. Esto puede demorar unos minutos.

**Nota**: Acá me mostró un inconveniente de que la máquina que había elegido no era compatible con la ubicación que había elegido `eastus` pero muestra un listado de las disponibles.

## Conectar la computadora al clúster
Ingresar el siguiente comando:
```
az aks get-credentiales --resource-group RG-medinillag --name cluster-medinillag
```

## verificar el correcto funcionamiento del clúster
Ingresar el siguiente comando:
```
kubectl get nodes
```
Esto muestra el estado del nodo.

**Nota**: En este caso al ejecutarlo a mi me mostró `pending`, lo que hice fue esperar unos segundos y al ejecutar el comando nuevamente me mostró el estado en `ready`.

## Código de app
Revisar el archivo `app.yml`

## Desplegar aplicación
Ingresar el siguiente comando:
```
kubectl apply -f app.yml
```
Aplicará el contenido del archivo indicado dentro del clúster

## Revisar servicios
Ingresar el siguiente comando:
```
kubectl get services
```
Esto mostrará una ip que la podemos copiar y pegar en el navegador para ver el contenido de la página.

O bien se puede con el siguiente comando:
```
curl http://<IP-EXTERNA>
```

## Destrucción
Ingresar el siguiente comando:
```
terraform destroy
```
**IMPORTANTE**: Ejecutar este comando al final de todo para evitar incurrir en consumos innecesarios y descontrolados.