import random


def generar_fechas_cumple():
    fechas = []
    for i in range(30000):
        año = random.randint(2002, 2017)
        mes = random.randint(1, 12)
        dia = random.randint(1, 25)

        if mes < 10:
            mes = "0" + str(mes)

        if dia < 10:
            dia = "0" + str(dia)
            
        fecha = str(año) + "-" + str(mes) + "-" + str(dia)
        fechas.append(fecha)
    return fechas

       
def generar_nombres():
    nombres = []
    file = open("names.txt","r")
    nombres = file.read().splitlines()
    file.close()
    return nombres

def generar_apellidos():
    apellidos = []
    file = open("apellidos.txt","r")
    apellidos = file.read().splitlines()
    file.close()
    return apellidos
    

    
def Person():
    file = open("Person.txt", "w")
    fechas = generar_fechas_cumple()
    nombres = generar_nombres()
    apellidos = generar_apellidos()
    generos = ["F", "M"]
    for i in range(35000):
        firstName = nombres[random.randint(0, 2180)]
        lastName = apellidos[random.randint(0, 999)]
        gender = generos[random.randint(0, 1)]
        birthDate = fechas[random.randint(0, 29999)]

        text =  "," + firstName + "," + lastName + "," + gender + "," + birthDate + "\n"

        file.write(text)
        
    file.close()


def cargar_nombres_magazine():
    names= []
    file = open("names_magazine.txt","r")
    names = file.read().splitlines()
    file.close()
    return names


def generar_magazine():
    nombres = cargar_nombres_magazine()
    fechas = generar_fechas_cumple()
    file = open("Magazine.txt", "w")
    for i in range(525):
        text = "," + nombres[i] + "," + str(random.randint(1500, 3500)) + "," + str(fechas[random.randint(0, 29999)]) + "\n"

        file.write(text)
    file.close()
        

def susb():
    file = open("Subscriptions.txt", "w")

    for i in range(150):
        idUser = random.randint(1, 1999)
        idMagazine = random.randint(1, 525)

        text = str(idUser) +"," + str(idMagazine) +"\n"

        file.write(text)
        
    file.close()



def Route_Address():
    file = open("routeAddress.txt", "w")

    for i in range(150):
        idRoute = random.randint(1, 110)
        idAddress = random.randint(1, 100)

        text = str(idRoute) +"," + str(idAddress) +"\n"

        file.write(text)
        
    file.close()


def Contract():
    file = open("contrat.txt", "w")
 
    idClient = 1
    while idClient <= 10:
        payment = random.randint(300000, 1000000)
        payrecurrence = random.randint(1, 3)
        amountLocal = random.randint(1, 15)
        text = "," + str(idClient) +","+ str(payment)+ ","+ str(payrecurrence)+"," + str(amountLocal) + "\n"
        idClient += 1
        file.write(text)
        
    file.close()



def CML():
    file = open("CML.txt", "w")
    file1 = open("Order_Client.txt", "w")

    for i in range(750):
        idEmployee = random.randint(1, 2000)
        idClient = random.randint(1, 10)
        idMagazine = random.randint(1, 525)
        idLocal = random.randint(1, 100)
        deliveryRe = random.randint(1, 3)
        
        text = str(idClient) +"," + str(idMagazine) + ","+ str(idLocal) + "," + str(deliveryRe) + "\n"

        text_Order = str(idEmployee)+ "," + str(idMagazine)+ "," + str(idClient)+"," + str(random.randint(10, 120)) + "\n"

        
        file.write(text)
        file1.write(text_Order)

    file1.close()    
    file.close()



def generar_fechas():
    fechas = []
    for i in range(2000):
        año = random.randint(2004, 2016)
        mes = random.randint(1, 12)
        dia = random.randint(1, 28)

        if mes < 10:
            mes = "0" + str(mes)
        if dia < 10:
            dia = "0" + str(dia)
            
        hora = random.randint(1, 23)
        minutos = random.randint(1, 59)
        segundos = random.randint(1, 59)

        if hora < 10:
            hora = "0" + str(hora)
        if minutos < 10:
            minutos = "0" + str(minutos)
        if segundos < 10:
            segundos = "0" + str(segundos)
            
        fecha = str(año) + "-" + str(mes) + "-" + str(dia) + " " + str(hora) + ":" + str(minutos) + ":" + str(segundos)     
        fechas.append(fecha)

    return fechas
    
def Register():
    file = open("Register.txt", "w")
    fechas = generar_fechas()
    for i in range(35000):
        idEmployee = random.randint(1, 2000)
        idLocal = random.randint(1, 100)
        arriveDate = fechas[random.randint(0, 1999)]
        
        text = "," + str(idEmployee) + ","+ str(idLocal) + "," + arriveDate + "\n"

        file.write(text)
        
    file.close()
