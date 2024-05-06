
#!/usr/local/ec/bin/python3
'''
todd@emersoncollective.com, 2/07/23
'''

# cba_checkup.py ####################################################
#
#   A script to check CBA certificate health.
#
#   0.1.0   2022.02.07  Quick CBA debugging tool.
#   0.1.0a  2022.02.07  Rewrote certificate decoding.
#   0.1.0b  2022.02.08  Removed unused code
#   0.1.0c  2022.02.08  rewrote file handling
#
#####################################################################
import subprocess
import pathlib


def main():
    final_result = 'Unknown error. '
    cert_file = pathlib.Path('/tmp/okta_cba_cert.txt')
    print("<result>" + 'start' + "</result>")

    try:
        print("<result>" + 'pre-security' + "</result>")
        cert_exp_raw = subprocess.check_output(['security', 'find-certificate', '-c', 'Okta MTLS', '-p']).decode("utf-8")
        cert_file.write_text(cert_exp_raw, encoding="utf-8")
        print("<result>" + 'post-security' + "</result>")

        cert_exp_read = subprocess.check_output(["openssl", "x509", "-text", "-noout", "-in", cert_file]).decode("utf-8").split('\n')
        print("<result>" + 'post-openssl' + "</result>")

        for line in cert_exp_read:
            if 'Not Before:' in line:
                cert_exp_string = line.split('Before: ')[1]
        
        if cert_exp_string:
            final_result = "CBA keychain present" + ', Expires: ' + cert_exp_string
        else:
            final_result = "No CBA keychain"
            
    except Exception as exception_message:
        final_result += exception_message
                
    print("<result>" + final_result + "</result>")
            
            
if __name__ == '__main__':
    main()