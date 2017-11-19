apellidos=[]
nombresF=[]
nombresM=[]
persona=[]
SSN=[]
telefonos=[]
magazine=[]
country=["Costa Rica","USA","Germany","Italy","India"]
province=["Cartago","San Jose","Heredia","Limon"]
city=["Desamparados","Escazu","Curridabat","La Union","Barva"]
address=[]
revista=[]

def generarMagazine():
	global magazine,revista
	for i in range(0,len(magazine)):
		revista+=[magazine[i]]
		revista+=[magazine[i]+"2"]
		revista+=[magazine[i]+"3"]
		revista+=[magazine[i]+"4"]

def generarAddress():
	global address
	zip=30000
	p=0
	for i in range(0,len(country)):
		for j in range(0,len(province)):
			for k in range(0,len(city)):
				temp=","+country[i]
				temp+=","+province[j]
				temp+=","+city[k]
				temp+=","+str(zip+p)
				address+=[temp]
				p+=1



def generarTelefono():
	global telefonos
	numero=80000000
	i=0
	while(i<2000):
		telefonos+=[numero+i]
		i+=1
def generarSSN():
	global SSN
	numero=300000000
	i=0
	while(i<2000):
		SSN+=[numero+i]
		i+=1


def readApellidos():
	global apellidos
	file = open("Apellidos.txt","r")
	apellidos=file.read().splitlines()
	file.close()
def readMagazine():
	global magazine
	file = open("magazines.txt","r")
	magazine=file.read().splitlines()
	file.close()

def readNombresF():
	global nombresF
	file = open("NombresF.txt","r")
	nombresF=file.read().splitlines()
	file.close()

def readNombresM():
	global nombresM
	file = open("NombresM.txt","r")
	nombresM=file.read().splitlines()
	file.close()

def generarPersona():
	global persona
	i=0
	while(i<50):
		tempNom=nombresF[i]
		j=0
		while(j<413):
			tempPersona=","
			tempPersona+=tempNom+","
			tempAp=apellidos[j]
			tempPersona+=tempAp+",F,2017-11-14"
			persona+=[tempPersona]
			j+=1
		i+=1
	i=0
	while(i<50):
		tempNom=nombresM[i]
		j=0
		while(j<413):
			tempPersona=","
			tempPersona+=tempNom+","
			tempAp=apellidos[j]
			tempPersona+=tempAp+",M,2017-11-14"
			persona+=[tempPersona]
			j+=1
		i+=1
	guardarPersona()


#Guarda las palabras indexadas en un documento
def guardarPersona():
	global persona
	file = open("Persona.txt","w")
	print(len(persona))
	hilera=""
	for i in range(0,len(persona)):
		hilera+=""+persona[i]+"\n"
	file.write(hilera)
	file.close()

def guardarEmpleado():
	global SSN,persona,telefonos

	file = open("Empleado.txt","w")
	hilera=""
	for i in range(0,len(SSN)):
		hilera+=","+str(SSN[i])+",1,"+str(i)+","+str(telefonos[i])+"\n"
	file.write(hilera)
	file.close()

def guardarAddress():
	global address
	file = open("Dirreccion.txt","w")
	hilera=""
	for i in range(0,len(address)):
		hilera+=address[i]+"\n"
	file.write(hilera)
	file.close()

def guardarMagazine():
	global address
	file = open("Revista.txt","w")
	hilera=""
	for i in range(0,len(revista)):
		hilera+=","+revista[i]+",1000,2017-11-14\n"
	file.write(hilera)
	file.close()	

def guaradarUser():
	global address
	file = open("Usuarios.txt","w")
	hilera=""
	for i in range(2001,4000):
		hilera+=","+str(i)+",micorreo"+str(i)+"@correo.com,password,"+str(200050605+i)+"\n"
	file.write(hilera)
	file.close()

def guardarLocal():
	file = open("Local.txt","w")
	hilera=""
	for i in range(0,110):
		hilera+=",Local"+str(i)+","+str(i)+"\n"
	file.write(hilera)
	file.close()	
def guardarRoute():
	file = open("Ruta.txt","w")
	hilera=""
	for i in range(0,110):
		hilera+=",Ruta"+str(i)+",2017-10-10 10:10:10\n"
	file.write(hilera)
	file.close()	

def guardarContract():
	file = open("Contrato.txt","w")
	hilera=""
	for i in range(0,10):
		hilera+=","+str(i)+",10000000,1\n"
	file.write(hilera)
	file.close()		

readApellidos()
readNombresM()
readNombresF()
readMagazine()
generarAddress()
generarSSN()
generarTelefono()
generarPersona()
generarMagazine()

#guardarContract()
#guardarRoute()
#guardarLocal()
#guaradarUser()
#guardarMagazine()
#generarPersona()
#guardarEmpleado()
#guardarAddress()