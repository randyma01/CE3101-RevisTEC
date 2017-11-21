import random

def generar_fechas_cumple():
    fechas = []
    for i in range(30000):
        año = random.randint(1965, 1995)
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

def susb():
    file = open("subscipstions.txt", "w")

    for i in range(150):
        idUser = random.randint(1, 1999)
        idMagazine = random.randint(1, 120)

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
    file = open("cml.txt", "w")
    
    for i in range(350):
        idClient = random.randint(1, 10)
        idMagazine = random.randint(1, 120)
        idLocal = random.randint(1, 100)
        deliveryRe = random.randint(1, 3)
        
        text = str(idClient) +"," + str(idMagazine) + ","+ str(idLocal) + "," + str(deliveryRe) + "\n"

        file.write(text)
        
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
