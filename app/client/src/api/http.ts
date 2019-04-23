const sharedOptions: RequestInit = {
  credentials: "same-origin",
  headers: new Headers({
    "Content-Type": "application/json"
  })
};

const responseHandler = <T>(
  resolve: (value: PromiseLike<T>) => void,
  reject: (value: PromiseLike<T>) => void
) => async (res: Response) => {
  try {
    const json = await res.json();
    const success = res.status >= 200 && res.status < 300;
    success ? resolve(json) : reject(json);
  } catch (error) {
    console.warn(error);
    reject(error);
  }
};

export const post = <T>(endpoint: string, data: { [k: string]: any } = {}) =>
  new Promise<T>((resolve, reject) => {
    fetch(endpoint, {
      ...sharedOptions,
      method: "post",
      body: JSON.stringify(data)
    })
      .then(r => responseHandler(resolve, reject)(r))
      .catch(e => {
        throw e;
      });
  });

export const get = <T>(endpoint: string) =>
  new Promise<T>((resolve, reject) => {
    fetch(endpoint, { ...sharedOptions, method: "get" })
      .then(r => responseHandler(resolve, reject)(r))
      .catch(e => {
        throw e;
      });
  });

export const del = <T>(endpoint: string) =>
  new Promise<T>((resolve, reject) => {
    fetch(endpoint, { ...sharedOptions, method: "delete" })
      .then(r => responseHandler(resolve, reject)(r))
      .catch(e => {
        throw e;
      });
  });

export const put = <T>(endpoint: string, data: { [k: string]: any } = {}) =>
  new Promise<T>((resolve, reject) => {
    fetch(endpoint, {
      ...sharedOptions,
      method: "put",
      body: JSON.stringify(data)
    })
      .then(r => responseHandler(resolve, reject)(r))
      .catch(e => {
        throw e;
      });
  });
