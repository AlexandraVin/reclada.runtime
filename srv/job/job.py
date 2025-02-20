import json
from enum import Enum


class Job:
    def __init__(self, _id, _type, task, command, input_parameters, status, runner_id):
        self.id = _id
        self.type = _type
        self.task = task
        self.command = command
        self.input_parameters = input_parameters
        self._status = status
        self.runner_id = runner_id

    def __repr__(self):
        return f'Job id={self.id} with status={self.status} is appointed to runner id={self.runner_id}'

    @property
    def status(self):
        """
        Gets job status

        """
        return self._status

    @status.setter
    def status(self, new_status):
        """
        Sets job status

        """
        if new_status not in JobStatus:
            raise ValueError(f'Job status {new_status.value} is not allowed')

        self._status = new_status


class JobStatus(Enum):
    NEW = 'new'
    PENDING = 'pending'
    RUNNING = 'running'
    FAILED = 'failed'
    SUCCESS = 'success'


class JobDB:
    def __init__(self, db_client):
        self.db_client = db_client

    def get_job(self, _id):
        """
        Gets job from DB and returns Job instance

        """
        data = {
            'class': 'Job',
            'id': _id,
            'attrs': {},
        }
        job = self.db_client.send_request('list', json.dumps(data))

        return Job(
            _id=job['id'],
            _type=job['type'],
            task=job['task'],
            command=job['command'],
            input_parameters=job['inputParameters'],
            status=job['status'],
            runner_id=job['runner'],
        )

    def get_runner_jobs(self, runner_id):
        """
        Gets new jobs from DB that are assigned to runner and returns list of Job instances

        """

        data = {
            'class': 'Job',
            'attrs': {
                'runner': runner_id,
                'status': JobStatus.NEW.value,
            },
        }
        jobs = self.db_client.send_request('list', json.dumps(data))

        return [Job(
            _id=job['id'],
            _type=job['type'],
            task=job['task'],
            command=job['command'],
            status=JobStatus.NEW,
            runner_id=job['runner'],
        ) for job in jobs]

    def save_job(self, job):
        """
        Updates job in DB (only updates status now, but needed to specify all required attrs)

        """
        data = {
            'class': 'Job',
            'id': job.id,
            'attrs': {
                'type': job.type,
                'task': job.task,
                'command': job.command,
                'status': job.status.value,
                'runner': job.runner_id,
            },
        }
        self.db_client.send_request('update', json.dumps(data))
