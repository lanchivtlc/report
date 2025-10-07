def relation(line):
    element = line.strip().split(', ')
    relationName = element[0]
    entities = element[1]
    relationship = element[2]
    return f"RelationName: {relationName}\nEntities: {entities}\nRelationship: {relationship}"
def req1(input, output):
    entities = []
    relationships = []
    current = {}
    with open(input, 'r') as file:
        for line in file:
            line = line.strip()
            if line.startswith('Entity:'):
                tableName = line.split(': ')
                current = {'Table': tableName[1], 'Attributes': []}
                entities.append(current)
            elif line.startswith('Attributes:'):
                for attributeLine in file:
                    attributeLine = attributeLine.strip()
                    if not attributeLine:
                        break
                    element = attributeLine.split(': ')
                    attributeName = element[0].strip()
                    attributeType = element[1].strip()
                    current['Attributes'].append((attributeName, attributeType))
            elif line.startswith('Relation:'):
                element = line.split(', ')
                relationName = element[0][10:]
                entitiesInvolved = element[1]
                relationship = element[2]
                relationships.append((relationName, entitiesInvolved, relationship))
    with open(output, 'w') as file:
        file.write("-------TABLE AND TYPE-------\n")
        file.write("\n")
        for entity in entities:
            file.write(f"{entity['Table']}(")
            attributes = [f"{attr[0]} {attr[1]}" for attr in entity['Attributes']]
            file.write(", ".join(attributes))
            file.write(")\n\n")
        file.write("------RELATIONSHIP------\n")
        file.write("\n")
        for relation in relationships:
            file.write(f"RelationName: {relation[0]}\nEntities: {relation[1]}\nRelationship: {relation[2]}\n\n")
#req2
def closure(attribute,functionalDependencies):
    closure = set(attribute)
    change = True
    while change:
        change = False
        for depen in functionalDependencies:
            if set(depen[0]).issubset(closure) and not set(depen[1]).issubset(closure):
                closure.update(depen[1])
                change = True
    return closure

def req2(input,output,selectedTable,selectedAttribute):
    tables = []
    current = {}
    with open(input, 'r') as file: 
        for line in file:
            line = line.strip()
            if line.startswith('Table:'):
                tableName = line.split(': ')
                current = {'Table': tableName[1], 'Functional Dependency': []}   
                tables.append(current)    
            elif line.startswith('Functional Dependency: '):
                element = line.split(': ')
                dependencies = element[1].split('; ')
                for dependency in dependencies:
                    left, right = dependency.split(' -> ')
                    current['Functional Dependency'].append((left.split(','),right.split(',')))
    with open(output, 'w') as file:
        for table in tables:
            if table['Table'] == selectedTable:
                result = closure([selectedAttribute], table['Functional Dependency'])
                file.write(f"Closure of {selectedAttribute} in {selectedTable}: {', '.join(result)}\n")  

req1("Input1.txt","Output1.txt")
#Điền tên bảng và thuộc tính cần bao đóng
req2("Input2.txt","Output2.txt",'QUANLY','manv')