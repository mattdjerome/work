 import subprocess
import xml.etree.ElementTree as ET
import csv

def extract_package_names_from_xml(xml_file):
	"""
	Extract package names from a given Jamf policy XML file.

	:param xml_file: Path to the XML file.
	:return: List of package names.
	"""
	package_names = []
	
	try:
		tree = ET.parse(xml_file)
		root = tree.getroot()
		
		# Adjust the path based on the structure of your XML
		for package in root.findall(".//package/name"):
			package_names.append(package.text.strip())
			
	except ET.ParseError as e:
		print(f"Error parsing XML file {xml_file}: {e}")
	except Exception as e:
		print(f"An error occurred while processing {xml_file}: {e}")
		
	return package_names

def scan_directory_for_xml_files(directory):
	"""
	Scan the given directory and its subdirectories for XML files using subprocess.

	:param directory: Root directory to start scanning.
	:return: List of XML file paths.
	"""
	xml_files = []
	try:
		result = subprocess.run(['find', directory, '-name', '*.xml'], capture_output=True, text=True, check=True)
		file_paths = result.stdout.strip().split('\n')
		xml_files = [path for path in file_paths if path]
	except subprocess.CalledProcessError as e:
		print(f"Error scanning directory {directory}: {e}")
	except Exception as e:
		print(f"An error occurred while scanning the directory: {e}")
		
	return xml_files

def save_to_csv(package_data, csv_file):
	"""
	Save the package data to a CSV file.

	:param package_data: List of tuples (filename, package_names).
	:param csv_file: Path to the CSV file.
	"""
	# Find the maximum number of packages
	max_packages = max(len(data[1]) for data in package_data) if package_data else 0
	
	with open(csv_file, mode='w', newline='', encoding='utf-8') as file:
		writer = csv.writer(file)
		
		# Create the header with dynamic number of columns
		header = ["Filename"] + [f"Package {i+1}" for i in range(max_packages)]
		writer.writerow(header)
		
		# Write each file and its packages to the CSV
		for filename, packages in package_data:
			row = [filename] + packages
			writer.writerow(row)
			
def main(directory, output_csv):
	"""
	Process all XML files in the given directory (and subdirectories) and save package names to a CSV file.

	:param directory: Directory containing XML files.
	:param output_csv: Path to the output CSV file.
	"""
	xml_files = scan_directory_for_xml_files(directory)
	package_data = []
	
	for xml_file in xml_files:
		print(f"Processing {xml_file}...")
		package_names = extract_package_names_from_xml(xml_file)
		if package_names:
			package_data.append((xml_file, package_names))
			
	save_to_csv(package_data, output_csv)
	print(f"Package data saved to {output_csv}")

if __name__ == "__main__":
	# Change these paths to the directory with XML files and desired CSV output file
	directory_path = "/Volumes/macOS Storage/Policies/20240805"
	output_csv_file = "/Users/mjerome/Desktop/packages.csv"
	main(directory_path, output_csv_file)
	