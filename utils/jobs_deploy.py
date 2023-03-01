import os
from fabric import Connection as connection,  task

server = 'user@host' 
tunnel = connection(server)
tunnel.connect_kwargs.password = 'pwd'
#with tunnel.cd(''):

def find_sh(job):
	if ' ' in job:
		raise Exception('No space is allowed in sh job file name. Pre-screen failed no job was submitted.')
	root, ext = os.path.splitext(job)
	if not ext or ext != '.sh':
		return
	return job

def deploy(job):
	tunnel.put(job, 'shell_scripts')
	on_server_path = 'shell_scripts/' + job
	tunnel.run('chmod u+x ' + on_server_path)
	result = tunnel.run('nohup ' + on_server_path + ' > /dev/null 2>&1 &', hide=True)

if __name__ == "__main__":
	print('locating shell script files...')
	ignore = ['.DS_Store']
	jobs = list(set(ignore)^set(os.listdir()))
	jobs = [find_sh(job) for job in jobs]
	jobs = [i for i in jobs if i is not None]
	
	print('Jobs deploying...')
	[deploy(job) for job in jobs]
	print('Jobs successfully deployed to server at ' + server)
else: 
	print('job deployment module imported')